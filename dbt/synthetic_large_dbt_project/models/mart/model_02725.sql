{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01798') }},
        {{ ref('model_02153') }},
        {{ ref('model_01752') }}
)
select id, 'model_02725' as name from sources
