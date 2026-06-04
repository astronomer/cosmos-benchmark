{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01826') }},
        {{ ref('model_01961') }},
        {{ ref('model_01866') }}
)
select id, 'model_02599' as name from sources
