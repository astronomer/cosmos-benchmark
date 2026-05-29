{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02055') }},
        {{ ref('model_02208') }}
)
select id, 'model_02841' as name from sources
