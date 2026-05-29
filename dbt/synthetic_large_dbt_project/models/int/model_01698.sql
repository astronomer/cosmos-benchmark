{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01299') }},
        {{ ref('model_01332') }},
        {{ ref('model_00925') }}
)
select id, 'model_01698' as name from sources
