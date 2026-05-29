{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01583') }},
        {{ ref('model_01690') }},
        {{ ref('model_01593') }}
)
select id, 'model_02587' as name from sources
