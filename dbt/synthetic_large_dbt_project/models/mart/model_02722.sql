{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02030') }},
        {{ ref('model_02192') }}
)
select id, 'model_02722' as name from sources
