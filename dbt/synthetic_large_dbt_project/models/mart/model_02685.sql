{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02002') }},
        {{ ref('model_01527') }},
        {{ ref('model_01889') }}
)
select id, 'model_02685' as name from sources
