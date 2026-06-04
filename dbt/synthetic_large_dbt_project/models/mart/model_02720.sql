{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01777') }},
        {{ ref('model_01795') }}
)
select id, 'model_02720' as name from sources
