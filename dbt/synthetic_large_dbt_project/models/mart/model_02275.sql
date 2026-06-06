{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01505') }},
        {{ ref('model_01988') }}
)
select id, 'model_02275' as name from sources
