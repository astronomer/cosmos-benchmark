{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00954') }},
        {{ ref('model_00950') }},
        {{ ref('model_01008') }}
)
select id, 'model_02085' as name from sources
