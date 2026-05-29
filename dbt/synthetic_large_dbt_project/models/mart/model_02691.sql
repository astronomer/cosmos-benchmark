{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01897') }},
        {{ ref('model_02048') }},
        {{ ref('model_02169') }}
)
select id, 'model_02691' as name from sources
