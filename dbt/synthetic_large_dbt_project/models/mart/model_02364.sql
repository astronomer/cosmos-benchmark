{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01667') }},
        {{ ref('model_01683') }}
)
select id, 'model_02364' as name from sources
