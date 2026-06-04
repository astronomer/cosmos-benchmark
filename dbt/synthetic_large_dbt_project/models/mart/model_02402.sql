{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01889') }}
)
select id, 'model_02402' as name from sources
