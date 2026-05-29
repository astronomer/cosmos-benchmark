{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01845') }},
        {{ ref('model_01690') }}
)
select id, 'model_02431' as name from sources
