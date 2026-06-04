{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01656') }},
        {{ ref('model_01645') }}
)
select id, 'model_02602' as name from sources
