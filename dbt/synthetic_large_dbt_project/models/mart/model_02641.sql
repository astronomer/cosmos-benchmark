{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02003') }},
        {{ ref('model_01507') }},
        {{ ref('model_01857') }}
)
select id, 'model_02641' as name from sources
