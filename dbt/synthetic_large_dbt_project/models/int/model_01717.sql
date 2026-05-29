{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01063') }},
        {{ ref('model_01214') }}
)
select id, 'model_01717' as name from sources
